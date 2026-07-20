# Security Notes

These are the controls I follow when publishing or operating this lab.

- I do not commit passwords, API keys, recovery codes, cookies, private certificates, or real `.env` files.
- I rotate credentials that appear in chat logs, screenshots, shell history, or exported notes.
- I keep administrative interfaces on trusted networks and prefer VPN access over direct exposure.
- I review published ports and remove anything that is not required.
- I use least-privilege service accounts where the application supports them.
- I test image upgrades before applying them broadly.
- I checksum configuration backups and encrypt copies stored outside the trusted network.
- I periodically test restoration instead of assuming a backup archive is usable.
- I treat example IP addresses and hostnames as documentation placeholders.

## Items intentionally excluded from this repository

- Credentials and secret files
- Private keys and certificates
- Internal inventory exports
- Application databases and user data
- Public exposure details
- Environment-specific access rules
