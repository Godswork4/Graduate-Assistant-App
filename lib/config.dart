enum Backend { local, pocketbase }

// Switch the active backend here.
const backend = Backend.pocketbase;

// PocketBase base URL
const String pbBaseUrl = 'http://127.0.0.1:8090';

// Optional: route Messages to a Support user by default.
// In PocketBase admin, open the users record for support@... and copy its ID here.
// Leave null to send messages to self.
const String? supportUserId = null;
