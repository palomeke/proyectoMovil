import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    println("DEBUG keystore props file detectado")
} else {
    println("DEBUG: key.properties NO existe en ${keystorePropertiesFile.absolutePath}")
}

// ---- Lee de -P primero, luego cae a key.properties ----
fun prop(name: String): String? = (project.findProperty(name) as String?)
    ?: keystoreProperties.getProperty(name)

val storeFileProp     = prop("storeFile")              // ej: keystore/my-release-key.jks
val storePasswordProp = prop("storePassword")
val keyAliasProp      = prop("keyAlias")
val keyPasswordProp   = prop("keyPassword")

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

    // ---- Firma release con merge de orígenes (P o file) ----
    signingConfigs {
        if (!storeFileProp.isNullOrBlank()
            && !storePasswordProp.isNullOrBlank()
            && !keyAliasProp.isNullOrBlank()
            && !keyPasswordProp.isNullOrBlank()
        ) {
            create("release") {
                // OJO: file() resuelve relativo a android/app, por eso funciona "keystore/..."
                storeFile = file(storeFileProp!!)
                storePassword = storePasswordProp
                keyAlias = keyAliasProp
                keyPassword = keyPasswordProp
                println("DEBUG signing -> absPath=${storeFile?.absolutePath} exists=${storeFile?.exists()}")
            }
        } else {
            println("DEBUG: credenciales de firma incompletas -> no se crea signingConfig.release")
        }
    }

    // ---- Build types (unificado) ----
    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Solo asigna si existe la config
            signingConfigs.findByName("release")?.let { sc ->
                signingConfig = sc
            }
        }
    }

    // ---- Flavors ----
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
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics-ndk")
}

flutter { source = "../.." }