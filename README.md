# shared-storage-terraform-state

Repositório de exemplo para criação de bucket S3 na AWS utilizando Terraform como IaC para persistir os estados dos repositórios de Terraform.

# Introdução

Estamos usando o Terraform para criar e atualizar recursos da AWS. Sempre que executamos o terraform plan ou o terraform apply, o Terraform consegue encontrar os recursos criados anteriormente e atualizá-los de acordo. Mas como o Terraform sabia quais recursos deveria gerenciar?

Toda vez que você executa o Terraform, ele registra informações sobre qual infraestrutura foi criada em um arquivo de estado (tfstate) do Terraform. Este arquivo está no formato JSON e possui mapeamento de recursos do terraform.

Porém, utilizando o Terraform dentro de uma Squad, onde possuem várias pessoas alterando/criando recursos e pipelines diferentes executando várias vezes durante o dia, como garantimos que o Terraform vai identificar que aquele recurso na AWS e qual o estado dele?

Para isso, utilizei esse repositório para criar uma estrutura de compartilhamento de estado remoto utilizando o `S3` e `DynamoDB`, sendo persistido o estado do Terraform dentro desse bucket para que nas próximas execuções o Terraform consiga recuperar o estado daquele recurso para conseguir gerar o Terraform Plan de forma correta, descrevendo apenas o que está sendo alterado/criado nesse repositório.

Para facilitar a execução do Terraform de forma automatizada para esse e seus próximos repositório, criei essa [`Action`](https://github.com/yagoalmeida/terraform_actions) para facilitar a integração com o bucket S3 como backend do Terraform.

## Tecnologias

| Tecnologia | Versão | Guia de instalação                                                  | Instalação obrigatória |
|------------|--------|---------------------------------------------------------------------|------------------------|
| Terraform  | 1.0.9  | [Link](https://learn.hashicorp.com/tutorials/terraform/install-cli) | Sim                    |

## Como utilizar

Esse repositório persiste o estado do Terraform de forma remota, salvando o tfstate em um `s3` na `AWS`, permitindo que
você possa trabalhar em equipe nesse repositório, que também matenha o estado do seus recursos criados via Terraform em
arquivos de estado evitando possíveis conflitos nas alterações desse recurso e que também recupere outputs criados
dentro de outros repositórios de Terraform dentro desse mesmo bucket.

### Executando via actions

* Para que as actions do github funcionem, basta configurar as secrets `AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY` no
  seu repositório.
* Caso queira entender um pouco mais sobre essa action, basta acessar esse [repositório](https://github.com/yagoalmeida/terraform_actions).

### Executando localmente

* Caso queira apenas rodar localmente sem configuração de estado remoto, basta passar o parâmetro `-backend=false` no
  comando `terraform init` ou comentar o arquivo `backend.tf`.
* Executar os comandos abaixo na seguinte ordem:
    * `terraform init -backend=false`
    * `terraform fmt -check`
    * `terraform validate -no-color`
    * `terraform plan -lock=false`
    * `terraform apply -lock=false`

Após isso basta acessar a sua conta na AWS, validar a criação dos recursos, executar novas pipeline se integrando com o bucket criado e partir para as próximas criações de recursos na Cloud via Terraform :). 
