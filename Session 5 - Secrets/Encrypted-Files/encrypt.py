import os
from azure.identity import DefaultAzureCredential
from azure.keyvault.keys.crypto import CryptographyClient, EncryptionAlgorithm

# Define the Key Vault URL and Key Identifier
key_vault_url = "https://inc-kv-001.vault.azure.net/"
key_identifier = "https://inc-kv-001.vault.azure.net/keys/terraform-bootcamp/c9d1190ceff249eab0b429d535813d02"

# Define the path of the local file to encrypt
file_path = "./decrypted-secrets.yaml"

# Create an instance of the CryptographyClient
credential = DefaultAzureCredential()
crypto_client = CryptographyClient(key=key_identifier, credential=credential)

# Read the contents of the local file
with open(file_path, "rb") as file:
    file_contents = file.read()

# Encrypt the file contents using the encryption key from Azure Key Vault
encrypted_data = crypto_client.encrypt(EncryptionAlgorithm.rsa_oaep, file_contents)

# Write the encrypted data to a new file or overwrite the existing file
encrypted_file_path = "./encrypted-secrets.yaml"
with open(encrypted_file_path, "wb") as encrypted_file:
    encrypted_file.write(encrypted_data.ciphertext)
os.remove(file_path)
