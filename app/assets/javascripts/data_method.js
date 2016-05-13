function DataMethod(el) {
  var parent = el.parentNode,
      form = document.createElement('form'),
      button = document.createElement('button'),
      className = el.getAttribute('class')

  form.setAttribute('method', el.getAttribute('data-method'))
  form.setAttribute('url', el.getAttribute('href'))
  parent.replaceChild(form, el)
  form.appendChild(el)
}

document.onreadystatechange = function(){
  if (document.readyState === 'complete') {
    Array.prototype.forEach.call(
      document.querySelectorAll('a[data-method]'),
      function(el) {  new DataMethod(el) }
    )
  }
}

