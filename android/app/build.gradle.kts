import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    println("DEBUG keystore props -> storeFile=${keystoreProperties.getProperty("storeFile")}, alias=${keystoreProperties.getProperty("keyAlias")}")
} else {
    println("DEBUG: key.properties NO existe en ${keystorePropertiesFile.absolutePath}")
}

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.qhantati.encomex"
    compileSdk = 35
    buildToolsVersion = "35.0.0"
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions { jvmTarget = "11" }

    defaultConfig {
        applicationId = "com.qhantati.encomex"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Firma release (solo si existe key.properties)
   signingConfigs {
        if (
            keystorePropertiesFile.exists() &&
            !keystoreProperties.getProperty("storeFile").isNullOrBlank() &&
            !keystoreProperties.getProperty("storePassword").isNullOrBlank() &&
            !keystoreProperties.getProperty("keyAlias").isNullOrBlank() &&
            !keystoreProperties.getProperty("keyPassword").isNullOrBlank()
        ) {
            create("release") {
                val sf = keystoreProperties.getProperty("storeFile")
                storeFile = file(sf)
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                println("DEBUG signing -> absPath=${storeFile?.absolutePath} exists=${storeFile?.exists()}")
            }
        } else {
            println("DEBUG: key.properties incompleto -> no se crea signingConfig.release")
        }
    }
     buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            if (signingConfigs.findByName("release") != null) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }

    // Flavors
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Encomex Dev")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "Encomex")
        }
    }

   buildTypes {
    getByName("release") {
        isMinifyEnabled = true
        isShrinkResources = true
        // Solo asigna si existe la config
        if (signingConfigs.findByName("release") != null) {
            signingConfig = signingConfigs.getByName("release")
        }
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics-ndk")
}

flutter { source = "../.." }