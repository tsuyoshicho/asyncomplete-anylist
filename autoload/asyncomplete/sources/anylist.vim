"=============================================================================
" File: anylist.vim
" Author: Tsuyoshi CHO
" Created: 2022-11-28
"=============================================================================

scriptencoding utf-8

function! asyncomplete#sources#anylist#completor(opt, ctx) abort
  let l:typed = a:ctx['typed']
  let l:col = a:ctx['col']
  let l:cache = []

  " check config is exists
  let l:config = get(a:opt, 'config', v:none)
  if l:config is v:none || v:t_dict != type(l:config)
    " config is nothing, exit
    call asyncomplete#complete(a:opt['name'], a:ctx, l:col, l:cache)
    return
  endif

  let l:matcher = get(l:config, 'matcher', '\w+$')
  let l:items = get(l:config, 'items', [])

  " check matcher is string and items is list
  if  v:t_string != type(l:matcher) || v:t_list != type(l:items)
    echomsg '[anylist]: matcher or items are invalid type:' string(l:matcher)  string(l:items)
    call asyncomplete#complete(a:opt['name'], a:ctx, l:col, l:cache)
    return
  endif

  " detect match string
  let l:kw = matchstr(l:typed, l:matcher)
  let l:kwlen = len(l:kw)
  let l:startcol = l:col - l:kwlen

  " process items
  for l:item in l:items
    if v:t_dict == type(l:item)
      call extend(l:cache, s:generate_list(a:opt, a:ctx, l:kw, l:item))
    endif
  endfor

  call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:cache)
endfunction

function s:generate_list(opt, ctx, kw, item) abort
  let l:name = get(a:item, 'name', 'none')
  let l:list = get(a:item, 'list', v:none)
  let l:Func = get(a:item, 'function', v:none)
  let l:args = get(a:item, 'args', [])

  let l:cache = []

  " type check
  if v:t_string != type(l:name)
    echomsg '[anylist]: name is invalid type:' string(a:item)
    return l:cache
  endif

  " generate base list
  if l:list isnot v:none && v:t_list == type(l:list)
    let l:cache = copy(l:list)
  elseif l:Func isnot v:none && v:t_func == type(l:Func) && v:t_list == type(l:args)
    try
      let l:cache = copy(call(l:Func, l:args))
    catch
      echomsg '[anylist]: function call failed:' string(a:item)
      return l:cache
    endtry
  else
    echomsg '[anylist]: list and function(args) do not exists or are invalid type:' string(a:item)
    return l:cache
  endif

  call filter(l:cache, {idx, v -> match(v, '\c^' . escape(a:kw, '\')) != -1})
  call map(l:cache, {idx, v -> {'dup' : 1, 'icase' : 1, 'menu' : '[anylist:' .. l:name .. ']', 'word': v}})

  return l:cache
endfunction

function! asyncomplete#sources#anylist#get_source_options(opts) abort
  return extend(extend({}, a:opts), {})
endfunction

" EOF
