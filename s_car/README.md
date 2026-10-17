# S-Car

Aplicativo mobile (Flutter) que lista carros famosos de marcas conhecidas.
Cada carro mostra **marca, modelo, ano de fabricação, velocidade máxima, performance e descrição**.
Usuários logados podem **comentar e dar uma nota de 1 a 10**.

## Funcionalidades

- Lista em grade com 20 carros famosos (Ferrari F40, Bugatti Veyron, Fusca, Gol GTI...).
- **Barra de pesquisa** por marca, modelo ou ano (ignora acentos e maiúsculas).
- **Login simples**: basta tocar no botão de login; o próprio app fornece o usuário (sem usuário e senha).
- Tela de detalhes com slides (imagem, velocidade, performance), ficha técnica e nota média.
- Comentário + nota (1 a 10) **somente com usuário logado**; o usuário pode apagar o próprio comentário (arrastar para a esquerda).
- Compartilhar o carro.

## Estrutura (igual ao projeto base)

```
lib/
  main.dart                  # app + provider + navegação por estado
  usuario.dart               # classe Usuario
  autenticador.dart          # login/logout automáticos
  gerenciador_estado.dart    # ChangeNotifier (tela atual, usuário, comentários, notas)
  telas/
    carros.dart              # lista + pesquisa + login/logout
    detalhes.dart            # detalhes, nota e comentários
  componentes/               # cartões e widgets reutilizáveis
recursos/
  jsons/carros.json          # carros (marca, modelo, ano, velocidade, performance...)
  jsons/comentarios.json     # comentários com "rating" de 1 a 10
  imagens/                   # logo e imagens dos carros
```

## Como executar

```bash
flutter pub get
flutter run
```

## Trocando as imagens

As imagens ficam em `recursos/imagens/carros/` e o nome do arquivo é definido em
`blobs[0].file` no `carros.json`. Para usar fotos reais, basta substituir os arquivos
mantendo os nomes (ou ajustar o JSON).
