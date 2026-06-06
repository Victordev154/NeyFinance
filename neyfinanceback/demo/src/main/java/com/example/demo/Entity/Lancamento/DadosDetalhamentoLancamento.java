package com.example.demo.Entity.Lancamento;

import com.example.demo.Entity.Categoria.Categoria;

import java.time.LocalDate;

public record DadosDetalhamentoLancamento(
        Long id,
        String descricao,
        Double valor,
        TipoLancamento tipoLancamento,
        Categoria categoria,
        LocalDate data
) {

    public DadosDetalhamentoLancamento(Lancamento lancamento) {
        this(
                lancamento.getId(),
                lancamento.getDescricao(),
                lancamento.getValor(),
                lancamento.getTipo(),
                lancamento.getCategoria(),
                lancamento.getData()
        );
    }

}