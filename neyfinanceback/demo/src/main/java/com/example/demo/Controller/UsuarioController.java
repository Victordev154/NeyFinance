package com.example.demo.Controller;

import com.example.demo.Entity.Usuario.DadosListagemUsuario;
import com.example.demo.Entity.Usuario.DadosUsuario;
import com.example.demo.Entity.Usuario.Usuario;
import com.example.demo.Entity.Usuario.UsuarioRepository;
import com.example.demo.Service.UsuarioService;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/usuarios")
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private UsuarioService usuarioService;

    @PostMapping
    @Transactional
    public ResponseEntity<DadosListagemUsuario> cadastrar(@RequestBody @Valid DadosUsuario dados) {
        Usuario salvo = usuarioService.cadastrar(dados);
        return ResponseEntity.ok(new DadosListagemUsuario(salvo));
    }

    @DeleteMapping("/{id}")
    @Transactional
    public ResponseEntity<Void> excluir(@PathVariable Long id) {
        usuarioRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}