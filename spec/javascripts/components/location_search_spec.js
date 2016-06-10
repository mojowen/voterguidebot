describe('LocationSearch', function() {

  beforeEach(function() {
    this.setUpComponent(LocationSearch, {})
    jasmine.Ajax.install()
  })

  afterEach(function() {
    jasmine.Ajax.uninstall()
  });

  it('renders a text input', function() {
    expect(this.dom.querySelector('input[type=text]')).not.toEqual(null)
  })

  it('renders all hidden inputs', function() {
    expect(this.dom.querySelectorAll('input[type=hidden]').length).toEqual(9)
  })

  it('renders some results', function() {
    var results = [
      { formatted_address: 'Great spot', place_id: 1 },
      { formatted_address: 'Another great spot', place_id: 2 },
      { formatted_address: 'One more spot', place_id: 3 }
    ]
    this.component.setState({ results: results })
    expect(this.dom.querySelectorAll('ul li a').length).toEqual(results.length)
  })

})
