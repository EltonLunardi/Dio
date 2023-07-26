def sacar(*, saldo, valor, extrato, limite, numero_saques, limite_saques):
    if saldo >= valor:
        saldo -= valor
        extrato.append(f"SAQUE: -{valor:.2f}")
        numero_saques += 1
        if numero_saques > limite_saques:
            saldo -= limite
            extrato.append(f"TARIFA LIMITE DE SAQUES: -{limite:.2f}")
        return saldo, extrato
    else:
        raise ValueError("Saldo insuficiente para realizar o saque.")


def depositar(saldo, valor, extrato):
    saldo += valor
    extrato.append(f"DEPÓSITO: +{valor:.2f}")
    return saldo, extrato


def exibir_extrato(saldo, *, extrato):
    print(f"Saldo: R${saldo:.2f}")
    print("Extrato:")
    for operacao in extrato:
        print(operacao)


def criar_usuario(lista_usuarios, nome, data_nascimento, cpf, endereco):
    for usuario in lista_usuarios:
        if usuario["cpf"] == cpf:
            raise ValueError(
                "CPF já cadastrado. Não é permitido cadastrar 2 usuários com o mesmo CPF.")

    usuario = {
        "nome": nome,
        "data_nascimento": data_nascimento,
        "cpf": cpf,
        "endereco": endereco
    }
    lista_usuarios.append(usuario)
    print("Usuário cadastrado com sucesso.")


def criar_conta(lista_contas, agencia, numero_conta, usuario):
    conta = {
        "agencia": agencia,
        "numero_conta": numero_conta,
        "usuario": usuario
    }
    lista_contas.append(conta)
    print("Conta corrente criada com sucesso.")


def main():
    lista_usuarios = []
    lista_contas = []

    while True:
        print("\nBem-vindo ao Banco DIO!")
        print("1 - Criar Usuário")
        print("2 - Criar Conta Corrente")
        print("3 - Realizar Depósito")
        print("4 - Realizar Saque")
        print("5 - Exibir Extrato")
        print("0 - Sair\n")

        opcao = input("Digite o número da opção desejada: ")

        if opcao == "1":
            nome = input("Nome do usuário: ")
            data_nascimento = input("Data de nascimento (dd/mm/aaaa): ")
            cpf = input("CPF (somente números): ")
            endereco = input(
                "Endereço (logradouro, nro - bairro - cidade/sigla estado): ")
            try:
                criar_usuario(lista_usuarios, nome,
                              data_nascimento, cpf, endereco)
            except ValueError as e:
                print(e)

        elif opcao == "2":
            agencia = "0001"
            numero_conta = len(lista_contas) + 1
            cpf = input(
                "CPF do usuário para vincular a conta (somente números): ")
            usuario = None
            for u in lista_usuarios:
                if u["cpf"] == cpf:
                    usuario = u
                    break
            if usuario:
                criar_conta(lista_contas, agencia, numero_conta, usuario)
            else:
                print("Usuário não encontrado. Por favor, cadastre o usuário primeiro.")

        elif opcao == "3":
            numero_conta = int(input("Número da conta: "))
            valor = float(input("Valor do depósito: "))
            conta = None
            for c in lista_contas:
                if c["numero_conta"] == numero_conta:
                    conta = c
                    break
            if conta:
                saldo, extrato = depositar(saldo=0, valor=valor, extrato=[])
                conta["usuario"]["conta"] = {
                    "saldo": saldo, "extrato": extrato}
                print("Depósito realizado com sucesso.")
            else:
                print("Conta não encontrada. Verifique o número da conta.")

        elif opcao == "4":
            numero_conta = int(input("Número da conta: "))
            valor = float(input("Valor do saque: "))
            conta = None
            for c in lista_contas:
                if c["numero_conta"] == numero_conta:
                    conta = c
                    break
            if conta:
                if "conta" in conta["usuario"]:
                    saldo_atual = conta["usuario"]["conta"]["saldo"]
                    extrato_atual = conta["usuario"]["conta"]["extrato"]
                else:
                    saldo_atual, extrato_atual = 0, []
                try:
                    saldo, extrato = sacar(
                        saldo=saldo_atual, valor=valor, extrato=extrato_atual,
                        limite=50.00, numero_saques=2, limite_saques=3
                    )
                    conta["usuario"]["conta"] = {
                        "saldo": saldo, "extrato": extrato}
                    print("Saque realizado com sucesso.")
                except ValueError as e:
                    print(e)
            else:
                print("Conta não encontrada. Verifique o número da conta.")

        elif opcao == "5":
            numero_conta = int(input("Número da conta: "))
            conta = None
            for c in lista_contas:
                if c["numero_conta"] == numero_conta:
                    conta = c
                    break
            if conta:
                if "conta" in conta["usuario"]:
                    saldo_atual = conta["usuario"]["conta"]["saldo"]
                    extrato_atual = conta["usuario"]["conta"]["extrato"]
                    exibir_extrato(saldo_atual, extrato=extrato_atual)
                else:
                    print("Conta ainda não teve nenhuma movimentação.")
            else:
                print("Conta não encontrada. Verifique o número da conta.")


if __name__ == "__main__":
    main()
