plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // 👈 Este debe estar aquí
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.tuempresa.inventarioropa"
    compileSdk = 35
    buildToolsVersion = "35.0.0"
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.tuempresa.inventarioropa"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
    release {
        isMinifyEnabled = true
        isShrinkResources = true
        signingConfig = signingConfigs.getByName("debug")
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
    dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))
    implementation("com.google.firebase:firebase-auth") // 👈 Imprescindible para Auth
    // Puedes añadir firebase-analytics si deseas
    // implementation("com.google.firebase:firebase-analytics")
}
}

flutter {
    source = "../.."
}