package com.example.demo.Entity.Lancamento;

import com.example.demo.Entity.Categoria.Categoria;
import com.example.demo.Entity.Usuario.Usuario;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
@Table(name = "lancamentos")
@Entity(name = "Lancamento")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class Lancamento {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String descricao;

    private Double valor;

    @Enumerated(EnumType.STRING)
    private TipoLancamento tipo;

    @Enumerated(EnumType.STRING)
    private Categoria categoria;

    private LocalDate data;

    @ManyToOne
    @JoinColumn(name = "usuario_id")
    private Usuario usuario;

    public Lancamento(LancamentoDTO dados, Usuario usuario ){
        this.descricao = dados.descricao();
        this.valor = dados.valor();
        this.data = dados.data();
        this.tipo = dados.tipo();
        this.usuario = usuario;
    }
}
