
# Instalando pacotes
install.packages("pdftools")
install.packages("stringr")
install.packages("dplyr")
install.packages("tidyr")
install.packages("readr")
install.packages("tesseract")



# Instalando Bibliotecas

library(pdftools)
library(stringr)
library(dplyr)
library(tidyr)
library(readr)

# FASE I ENTENDENDO OS DADOS 
# Ler todo o texto do PDF
arquivo <- " C:/Users/Floresteira/Documents/Luisgit/cadastro"
texto <- pdf_text("cadastro.pdf") |> paste(collapse = "\n")
texto [1]
texto <- str_split(texto,  "\\n")

# Regex para capturar os campos
# Regex para capturar os campos
library(stringr)

library(stringr)
# Analizando o numéro de linhas no (pdf)  27 .
linhas <- texto[[1]]

# Transformando as linhas em um unico texto
texto_completo <- paste(linhas, collapse = " ")

resultado <- str_match_all(texto_completo, padrao)[[1]]

# O resultado
print(resultado)

# FASE II

linhas <- texto[[1]]
print(linhas)

# Encontrando  onde começa cada pessoa:
inicio <- which(
  str_detect(linhas, regex("^Nome:", ignore_case = TRUE))
)

inicio # resultado 1  8  14  21

# CRIANDO OS REGISTROS 

registros <- list()

for (i in seq_along(inicio)) {
  
  inicio_atual <- inicio[i]
  
  if (i < length(inicio)) {
    fim_atual <- inicio[i + 1] - 1
  } else {
    fim_atual <- length(linhas)
  }
  
  registros[[i]] <- paste(
    linhas[inicio_atual:fim_atual],
    collapse = " "
  )
}

# RESULTADO DOS REGISTROS 
cat(registros[[1]])

cat(registros[[2]])

# USANDO O RAGEX MAIS FLEXIVEL 

padrao <- regex(
  paste0(
    "Nome:\\s*(?<Nome>.*?)\\s*\\(aka\\s*(?<Apelido>.*?)\\),?\\s*",
    "(?:Data de nascimento|Dt nasc):\\s*(?<Nascimento>.*?)\\s*",
    "Endereço:\\s*(?<Endereco>.*?)\\s*",
    "CEP:\\s*(?<CEP>[0-9.\\-]+)\\s*",
    "(?:Tel|Telefone):\\s*(?<Telefone>.*?)\\s*",
    "CPF:\\s*(?<CPF>[0-9.\\-]+)"
  ),
  ignore_case = TRUE
)

resultado1 <- str_match(registros[[1]], padrao)

print(resultado1)

# Colocando apelido apenas para o primeiro

resultado1[, -1] # tendo servido vamos aplicar para todos 

resultado <- do.call(
  rbind,
  lapply(registros, function(x) {
    str_match(x, padrao)[-1]
  })
)

# Colocando na tabela 

dados <- as.data.frame(resultado, stringsAsFactors = FALSE)

dados

# VAMOS IMPRIMIR oOS DADOS NO EXCEL 

install.packages("openxlsx") # INSTALANDO PACOTE 
library(openxlsx)

write.xlsx(
  dados,
  "dados_extraidos.xlsx",
  rowNames = FALSE
)

# FIM DA ATIVIDADE

