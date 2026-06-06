package com.example.demo.Service;

import com.example.demo.Entity.Lancamento.DadosDetalhamentoLancamento;
import com.example.demo.Entity.Lancamento.Lancamento;
import com.example.demo.Entity.Lancamento.LancamentoDTO;
import com.example.demo.Entity.Lancamento.LancamentoRepository;
import com.example.demo.Entity.Usuario.Usuario;
import com.example.demo.Entity.Usuario.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LancamentoService {

    @Autowired
    private LancamentoRepository lancamentoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    public DadosDetalhamentoLancamento cadastrarLancamento(LancamentoDTO lancamentoDTO) {

        Usuario usuario = usuarioRepository.findById(lancamentoDTO.usuarioId())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado com id: " + lancamentoDTO.usuarioId()));

        Lancamento lancamento = new Lancamento();
        lancamento.setDescricao(lancamentoDTO.descricao());
        lancamento.setValor(lancamentoDTO.valor());
        lancamento.setTipo(lancamentoDTO.tipo());
        lancamento.setCategoria(lancamentoDTO.categoria());
        lancamento.setData(lancamentoDTO.data());
        lancamento.setUsuario(usuario);

        lancamentoRepository.save(lancamento);

        return new DadosDetalhamentoLancamento(lancamento);
    }

    public List<DadosDetalhamentoLancamento> listarPorUsuario(Long usuarioId) {
        return lancamentoRepository.findByUsuarioId(usuarioId)
                .stream()
                .map(DadosDetalhamentoLancamento::new)
                .toList();
    }

    public void excluirLancamento(Long id) {
        if (!lancamentoRepository.existsById(id)) {
            throw new RuntimeException("Lançamento não encontrado com id: " + id);
        }
        lancamentoRepository.deleteById(id);
    }
}