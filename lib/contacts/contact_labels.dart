import 'contact.dart';

const kDonationAddresses = <Contact>[];

final labeledAddresses = Map.fromEntries(
  kDonationAddresses.map((e) => MapEntry(e.address, e)),
);
