package com.example.demo.Service;

import com.example.demo.Entity.Usuario.DadosUsuario;
import com.example.demo.Entity.Usuario.Usuario;
import com.example.demo.Entity.Usuario.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public Usuario cadastrar(DadosUsuario dadosUsuario) {
        Usuario usuario = new Usuario(dadosUsuario);
        usuario.setSenha(passwordEncoder.encode(dadosUsuario.senha()));
        return usuarioRepository.save(usuario);
    }
}