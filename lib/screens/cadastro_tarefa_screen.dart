import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import 'tarefas_screen.dart' show formatarData;

class CadastroTarefaScreen extends StatefulWidget {
  final Tarefa? tarefa;
  const CadastroTarefaScreen({super.key, this.tarefa});

  @override
  State<CadastroTarefaScreen> createState() => _CadastroTarefaScreenState();
}

class _CadastroTarefaScreenState extends State<CadastroTarefaScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descCtrl;
  late DateTime _data;
  late String _prioridade;
  late bool _concluida;
  bool _salvando = false;

  bool get _editando => widget.tarefa != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tarefa;
    _tituloCtrl = TextEditingController(text: t?.titulo ?? '');
    _descCtrl = TextEditingController(text: t?.descricao ?? '');
    _data = t?.dataVencimento ?? DateTime.now().add(const Duration(days: 1));
    _prioridade = t?.prioridade ?? 'Média';
    _concluida = t?.concluida ?? false;
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (escolhida != null) setState(() => _data = escolhida);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);
    try {
      final service = FirebaseService(AuthService().usuarioAtual!.uid);
      final tarefa = Tarefa(
        id: widget.tarefa?.id ?? '',
        titulo: _tituloCtrl.text.trim(),
        descricao: _descCtrl.text.trim(),
        dataVencimento: _data,
        prioridade: _prioridade,
        concluida: _concluida,
      );
      if (_editando) {
        await service.atualizar(tarefa);
      } else {
        await service.cadastrar(tarefa);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _salvando = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editando ? 'Editar tarefa' : 'Nova tarefa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloCtrl,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o título' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _escolherData,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data de vencimento',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(formatarData(_data)),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _prioridade,
                decoration: const InputDecoration(labelText: 'Prioridade'),
                items: Tarefa.prioridades
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => _prioridade = v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<bool>(
                value: _concluida,
                decoration: const InputDecoration(labelText: 'Situação'),
                items: const [
                  DropdownMenuItem(value: false, child: Text('Pendente')),
                  DropdownMenuItem(value: true, child: Text('Concluída')),
                ],
                onChanged: (v) => setState(() => _concluida = v!),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _salvando ? null : _salvar,
                  child: Text(_editando ? 'Salvar alterações' : 'Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
