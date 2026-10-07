# Changelog

## 1.3.0 - Sedra Wallet (Karya Langit Digital)

* **App Identity & Rebranding:** Completely rebranded to Sedra Wallet by Karya Langit Digital (`com.karyalangitdigital.sedracoinwallet`).
* **Performance Boost:** Significant improvements to the transactions list refresh mechanism. Balances, UTXOs, and transactions now sync concurrently, reducing loading times drastically.
* **Network Reliability:** Implemented a smart and seamless fallback mechanism. If the primary gRPC connection (HTTP/2 TLS) fails or ALPN is not supported by the node, the wallet intelligently falls back to the REST API without crashing.
* **Data Parsing Fixes:** Fixed severe `type 'int' is not a subtype of type 'String'` crashes during REST API fallback by adding robust `BigInt` parsing logic for handling large numeric data across different platforms.
* **AI Assistant Updates:** The Sedra Assistant is now strictly focused on the Sedra ecosystem. It will politely decline non-crypto or irrelevant topics. Also removed the redundant initial greeting when opening the AI floating chat.
* **Updated Licensing & Documentation:** Restructured `README.md` to highlight Sedra-specific features (BlockDAG, GHOSTDAG, Compound UTXOs, AI integration) and updated the `LICENSE` under KARYA LANGIT DIGITAL.

## 1.2.0 - Sedra Wallet

* Integrated AI Assistant for the Sedra Ecosystem.
* Added support for multiple languages.
* General bug fixes and UI improvements.

## 1.1.0 - Sedra Wallet

* Implemented Compound UTXOs to optimize wallet performance and fees.
* Support for custom nodes and gRPC configurations.

## 1.0.0 - Sedra Wallet Initial Release

* First stable release of Sedra Wallet supporting basic send, receive, QR code scanning, and biometric security.
