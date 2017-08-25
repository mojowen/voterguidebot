describe('InputComponent', function() {

  beforeEach(function() {
    this.setUpComponent(InputComponent, {})
  })

  describe('with initial value', function(){
    beforeEach(function() {
      this.setUpComponent(InputComponent, { value: null, default: 'default' })
    })
    it('renders initial value', function() {
      expect(this.dom.querySelector('input').value).toEqual('default')
    })
  })

  describe('with initial value', function(){
    beforeEach(function() {
      this.setUpComponent(InputComponent, { value: 'init', default: 'default' })
    })
    it('renders initial value', function() {
      expect(this.dom.querySelector('input').value).toEqual('init')
    })
  })

  it('renders input by default', function() {
    expect(this.dom.querySelector('input')).not.toEqual(null)
  })

  it('renders text by default', function() {
    expect(this.dom.querySelector('input[type=text]')).not.toEqual(null)
  })

  describe('with onChange callback', function(){
    beforeEach(function() {
      this.myCallback = function() { return false }
      spyOn(this, 'myCallback')
      this.setUpComponent(InputComponent, { onChange: this.myCallback })
      this.component.refs.input.value = 'values'
      Utils.Simulate.change(this.component.refs.input)
    })

    it('runs value callback on change', function() {
      expect(this.myCallback).toHaveBeenCalled()
    })
  })

  describe('when type is email', function() {
    beforeEach(function() {
      this.setUpComponent(InputComponent, { type: 'email' })
    })
    it('renders type when passed it', function() {
      expect(this.dom.querySelector('input[type=text]')).toEqual(null)
      expect(this.dom.querySelector('input[type=email]')).not.toEqual(null)
    })
  })

  describe('when element is textarea', function() {
    beforeEach(function() {
      this.setUpComponent(InputComponent, { element: 'textarea' })
    })
    it('renders type when passed it', function() {
      expect(this.dom.querySelector('input')).toEqual(null)
      expect(this.dom.querySelector('textarea')).not.toEqual(null)
    })
  })
  describe('when element is imagecomponent', function() {
    beforeEach(function() {
      this.setUpComponent(InputComponent, { element: 'ImageComponent' })
    })
    it('renders type when passed it', function() {
      expect(this.dom.querySelector('div.dz-clickable')).not.toEqual(null)
    })
  })

  describe('when value is passed', function() {
    beforeEach(function() {
      this.setUpComponent(InputComponent, { value: 'super cool' })
    })
    it('renders a input with value if passed one', function() {
      expect(this.dom.querySelector('input').value).toEqual('super cool')
    })
  })

  describe('when after component is passed', function() {
    beforeEach(function() {
      this.setUpComponent(InputComponent, { after: new React.DOM.em })
    })
    it('renders a after component if passed one', function() {
      expect(this.dom.querySelector('em')).not.toEqual(null)
    })
  })

  describe('when afterLabel component is passed', function() {
    beforeEach(function() {
      this.setUpComponent(InputComponent, { afterLabel: new React.DOM.em })
    })
    it('renders a after component if passed one', function() {
      expect(this.dom.querySelector('em')).not.toEqual(null)
    })
  })
})
