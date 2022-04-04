# Terraform Azure

Usando o Terraform para:

- Criar uma máquina virtual linux na Azure.

- Instalar o servidor Apache2 na VM.

- Fazer deploy de uma simples aplicação "hello world".

## Pré-requisitos
* azure-cli - `https://docs.microsoft.com/en-us/cli/azure/install-azure-cli`
* terraform - `https://www.terraform.io/downloads`

## Setup do Projeto

* Clonar o projeto - `https://github.com/lucascunha/terraform-azure.git`
* Inicializar o diretório de projeto do Terraform - `terraform init`
* Criar o plano de execução - `terraform plan`
* Executar o plano - `terraform apply`

Serão solicitados os dados de login e senha:
* user = `adminuser`
* password = `Password1234!`

Você pode criar um arquivo 'terraform.tfvars' contendo o usuário e a senha, assim o terraform poderá carregar os dados a partir deste arquivo. Neste caso, não se esqueça de adiciona-lo ao '.gitignore'. Este arquivo não deve ser enviado para o repositório.

Alternativamente, você pode armazenar os dados de login nas variáveis do sistema:

- export TF_VAR_user=
- export TF_VAR_password=

## Não esquecer

Ao terminar de utilizar, não esqueça de apagar os recursos criados para evitar cobranças desnecessárias:

* Comando - `terraform destroy`