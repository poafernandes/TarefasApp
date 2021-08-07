//
//  ViewController.swift
//  TarefasApp
//
//  Created by Alexandre on 07/08/21.
//

import UIKit

//Adiciona os métodos para alimentar a Table View com os dados
class ViewController: UIViewController, UITableViewDataSource {
    
    //Definindo o componente básico da lista, a tabela
    private let tabela: UITableView = {
        let tabela = UITableView()
        tabela.register(UITableViewCell.self,
                       forCellReuseIdentifier: "celula")
        return tabela
    }()
    
    var items = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Resgata as notas do usuário ou cria uma array vazia
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        
        title = "Lista de Tarefas"
        
        //Cria a subview para utilizar a tabela
        view.addSubview(tabela)
        tabela.dataSource = self
        
        //Botão de adicionar nova nota
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(apertouAdd))
    }
    
    //Função de abrir o alerta para registrar a nota
    @objc private func apertouAdd(){
        let modal = UIAlertController(title: "Novo Item", message: "Escreva o item", preferredStyle: .alert)
        
        modal.addTextField{campoTexto in campoTexto.placeholder = "Escreva aqui..."}
        
        //Registra os botões do alerta
        modal.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        modal.addAction(UIAlertAction(title: "Salvar", style: .default, handler: { [weak self] (_) in
            if let campoTexto = modal.textFields?.first {
                if let texto = campoTexto.text, !texto.isEmpty {
                    
                    //Busca as notas já salvas do usuário e adiciona a nova, se não tiver cria uma string vazia e começa
                    DispatchQueue.main.async {
                        var notas = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        notas.append(texto)
                        UserDefaults.standard.setValue(notas, forKey: "items")
                        self?.items.append(texto)
                        self?.tabela.reloadData()
                    }
                }
            }
        }))
        
        present(modal,animated: true)
    }
    
    //Atribui a tabela para toda tela
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabela.frame = view.bounds
    }
    
    //Define a quantidade de linhas que a tabela vai ter baseada na quantidade de itens salvos
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //Cria a celula e alimenta com o texto
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula",
                                                   for: indexPath)
        
        celula.textLabel?.text = items[indexPath.row]
        
        return celula
    }


}

