package com.example.demo.Entity.Lancamento;

import com.example.demo.Entity.Categoria.Categoria;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

public record LancamentoDTO(

        @NotNull
        Long usuarioId,

        String descricao,

        Double valor,

        TipoLancamento tipo,

        Categoria categoria,

        @NotNull
        LocalDate data

) {
}