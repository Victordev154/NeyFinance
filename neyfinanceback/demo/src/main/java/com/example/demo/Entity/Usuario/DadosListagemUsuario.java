package com.example.demo.Entity.Usuario;

public record DadosListagemUsuario(Long id,String nome){
    public DadosListagemUsuario(Usuario usuario){
        this(usuario.getId(), usuario.getNome());
    }


}
