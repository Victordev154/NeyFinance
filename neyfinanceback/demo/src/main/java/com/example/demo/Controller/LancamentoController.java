package com.example.demo.Controller;

import com.example.demo.Entity.Lancamento.DadosDetalhamentoLancamento;
import com.example.demo.Entity.Lancamento.LancamentoDTO;
import com.example.demo.Service.LancamentoService;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/lancamentos")
public class LancamentoController {

    @Autowired
    LancamentoService lancamentoService;

    @PostMapping
    @Transactional
    public ResponseEntity<DadosDetalhamentoLancamento> cadastrarLancamento(@RequestBody @Valid LancamentoDTO lancamentoDTO) {
        DadosDetalhamentoLancamento detalhamentoLancamento = lancamentoService.cadastrarLancamento(lancamentoDTO);
        return ResponseEntity.ok(detalhamentoLancamento);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<DadosDetalhamentoLancamento>> listarPorUsuario(@PathVariable Long usuarioId) {
        List<DadosDetalhamentoLancamento> lista = lancamentoService.listarPorUsuario(usuarioId);
        return ResponseEntity.ok(lista);
    }

    // FIX: era @GetMapping — trocado para @DeleteMapping
    @DeleteMapping("/{id}")
    @Transactional
    public ResponseEntity<Void> excluirLancamento(@PathVariable Long id) {
        lancamentoService.excluirLancamento(id);
        return ResponseEntity.noContent().build();
    }
}