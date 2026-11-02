package com.karyalangitdigital.sedracoinwallet

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Wallet security: block screenshots, screen recording and the
        // app preview in the recent-tasks switcher so seed phrases,
        // addresses and amounts can never be captured by other apps
        // or shoulder-surfing.
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE,
        )
    }
}
