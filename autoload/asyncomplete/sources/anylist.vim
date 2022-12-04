"=============================================================================
" File: mrw.vim
" Author: Tsuyoshi CHO
" Created: 2022-11-28
"=============================================================================

scriptencoding utf-8

function! asyncomplete#sources#anylist#completor(opt, ctx) abort
  " check config is exists
  if !has_key(a:opt, 'config')
    call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, [])
    return
  endif

  l:items = get(a:opt['config'], 'items', [])

  " check items is list
  if v:t_list != type(l:items)
    call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, [])
    return
  endif

  l:cache = []
  for l:item in l:items
    if v:t_dict == type(l:item)
      call s:s:generate_list(a:opt, a:ctx, l:item)
    endif
  endfor

endfunction

function s:generate_list(opt, ctx, item) abort
  let l:name = get(a:item, 'name', 'anylist')
  let l:matcher = get(a:item, 'matcher', '\w+$')
  let l:list = get(a:item, 'list', v:none)
  let l:func = get(a:item, 'function', v:none)
  let l:args = get(a:item, 'args', [])

  " type check
  if v:t_string != type(l:name) || v:t_string != type(l:matcher)
    echomsg '[anylist]: name or matcher are invalid type:' string(a:item)
    return
  endif

  " generate base list
  if l:list isnot v:none && v:t_list == type(l:list)
    let l:cache = l:list
  elseif l:func isnot v:none && v:t_func == type(l:func) && v:t_list == type(l:args)
    try
      let l:cache = call(l:func, l:args)
    catch
      echomsg '[anylist]: function call failed:' string(a:item)
      return
    endtry
  else
    echomsg '[anylist]: list and function do not exists or are invalid type:' string(a:item)
    return
  endif

  let l:typed = a:ctx['typed']
  let l:col = a:ctx['col']

  let l:kw = matchstr(l:typed, l:matcher)
  let l:kwlen = len(l:kw)
  let l:startcol = l:col - l:kwlen

  call filter(l:cache, {idx, v -> match(v, '\c^' . escape(l:kw, '\')) != -1})
  call map(l:cache, {idx, v -> {'dup' : 1, 'icase' : 1, 'menu' : '[' .. l:name .. ']', 'word': v}})

  call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:cache)
endfunction

function! asyncomplete#sources#anylist#get_source_options(opts) abort
  return extend(extend({}, a:opts), {})
endfunction

" EOF
