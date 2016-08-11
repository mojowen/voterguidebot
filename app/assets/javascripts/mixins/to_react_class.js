function to_react_class(component_string) {
  if( typeof window[component_string] === 'undefined' ) return component_string
  return window[component_string]
}
