package com.example.demo.Entity.Usuario;

import jakarta.validation.constraints.NotNull;

public record DadosUsuario(

        @NotNull
        String nome,

        @NotNull
        String login,

        @NotNull
        String senha) {
}
