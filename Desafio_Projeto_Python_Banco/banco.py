from datetime import datetime


class Banco:
    def __init__(self):
        self.saldo = 0
        self.depositos = []
        self.saques = []
        self.saques_diarios = 0
        self.ultimo_saque = datetime.now()

    def deposito(self, valor):
        if valor > 0:
            self.saldo += valor
            self.depositos.append(valor)
            return True
        return False

    def saque(self, valor):
        if valor > 0 and self.saldo >= valor and self.saques_diarios < 3 and valor <= 500:
            self.saldo -= valor
            self.saques.append(valor)
            self.saques_diarios += 1
            self.ultimo_saque = datetime.now()
            return True
        return False

    def extrato(self):
        if not self.depositos and not self.saques:
            return "Não foram realizadas movimentações."

        extrato_texto = "Extrato:\n"
        for deposito in self.depositos:
            extrato_texto += f"Depósito: R$ {deposito:.2f}\n"

        for saque in self.saques:
            extrato_texto += f"Saque: R$ {saque:.2f}\n"

        extrato_texto += f"Saldo atual: R$ {self.saldo:.2f}"
        return extrato_texto


def exibir_menu():
    print("\nBem-vindo ao Banco DIO!")
    print("Escolha uma opção:")
    print("1 - Depósito")
    print("2 - Saque")
    print("3 - Extrato")
    print("4 - Sair\n")


banco = Banco()

while True:
    exibir_menu()
    opcao = input("Digite o número da opção desejada: \n")

    if opcao == "1":
        valor_deposito = float(input("Digite o valor do depósito: \n"))
        if banco.deposito(valor_deposito):
            print("Depósito realizado com sucesso!\n")
        else:
            print("Valor inválido para depósito. Tente novamente!\n")

    elif opcao == "2":
        valor_saque = float(input("Digite o valor do saque: \n"))
        if valor_saque > 500:
            print("Valor de saque não permitido!\n")
        elif banco.saque(valor_saque):
            print("Saque realizado com sucesso!\n")
        else:
            if datetime.now().date() == banco.ultimo_saque.date():
                print("Limite de saques diários atingido!\n")
            else:
                print("Valor inválido para saque ou saldo insuficiente!\n")

    elif opcao == "3":
        print(banco.extrato())

    elif opcao == "4":
        print("Obrigado por utilizar o Banco DIO. Volte sempre!\n")
        break

    else:
        print("Opção inválida. Digite uma opção válida (1, 2, 3 ou 4)!\n")
