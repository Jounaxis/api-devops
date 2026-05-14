package main.java.br.fiap.apidevops.repository;

import br.fiap.apidevops.model.Produto;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProdutoRepository extends JpaRepository<Produto, Long> {
}