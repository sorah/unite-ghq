let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
 \  'name': 'ghq',
 \  'default_action': { '*': 'lcd' },
 \  'default_kind': 'directory'
 \ }


if exists('g:unite_ghq_command')
  let s:ghq_command = g:unite_ghq_command
else
  let s:ghq_command = "ghq"
endif

function! s:ghq_roots()
  return map(
        \ split(unite#util#system('git config --path --get-all ghq.root'), "\n"),
        \ 'resolve(expand(v:val)). "\/"'
        \ ) 
endfunction

function! s:ghq_root_prefix_pattern()
  let l:roots = s:ghq_roots()
  return "\\V" . join(l:roots, "\\|")
endfunction

function! unite#sources#ghq#define()
  return s:unite_source
endfunction

function! s:unite_source.gather_candidates(args, context)
  let l:root_pat = s:ghq_root_prefix_pattern()
  return map(
    \   split(unite#util#system(s:ghq_command . ' list --full-path'), "\n"),
    \   '{
    \     "word": substitute(v:val, l:root_pat, "", ""),
    \     "action__directory": fnamemodify(v:val, ":p:h"),
    \     "action__path": v:val
    \   }'
    \ )
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
