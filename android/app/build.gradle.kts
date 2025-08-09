import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("android/key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
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
        if (keystorePropertiesFile.exists()) {
            create("release") {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
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
            // Usa la firma release si la definimos
            if (signingConfigs.findByName("release") != null) {
                signingConfig = signingConfigs.getByName("release")
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        getByName("debug") { /* configs debug si necesitas */ }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics-ndk")
}

flutter { source = "../.." }