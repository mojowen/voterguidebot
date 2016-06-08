describe('FieldFormRow', function() {
  beforeEach(function() {
    this.props = {
      name: 'Great Field',
      element: 'textarea',
      example: '2016 Denver Voter Guide',
      limit: 40,
      name: 'title_page_subheader'
    }
    this.setUpComponent(FieldFormRow, this.props)
  })

  it('creates inputs for the guides', function() {
    expect(this.dom.querySelectorAll('textarea').length).toEqual(1)
  })

  it('empty if no value passed', function() {
    expect(this.dom.querySelector('textarea').value).toEqual('')
    expect(this.component.state.value).toEqual('')
  })

  it('shows remaining characters', function() {
    var typed = 'what what what'
    this.component.updateValue({ target: { value: typed }})
    expect(parseInt(this.component.refs.remaining.innerText)).toEqual(
      this.component.props.limit - typed.length)
  })

  it('renders the previews', function() {
    this.component.updateValue({ target: { value: 'update_preview' }})
    expect(this.component.refs.preview.innerText).toEqual('update_preview')
  })

  describe('if a value is passed as prop', function() {
    beforeEach(function() {
      this.props = {
        name: 'Great Field',
        element: 'textarea',
        example: '2016 Denver Voter Guide',
        limit: 40,
        name: 'title_page_subheader',
        value: 'what'
      }
      this.setUpComponent(FieldFormRow, this.props)
    })
    it('assigns a value if passed', function() {
      expect(this.dom.querySelector('textarea').value).toEqual(this.props.value)
      expect(this.component.state.value).toEqual(this.props.value)
    })
    it('shows remaining characters', function() {
      expect(parseInt(this.component.refs.remaining.innerText)).toEqual(
        this.component.props.limit - this.props.value.length)
    })
    it('renders the previews', function() {
      expect(this.component.refs.preview.innerText).toEqual(this.props.value)
    })
  })

  describe('with an image field', function() {
    beforeEach(function() {
      var props = {
        label: 'Logo',
        placeholder: 'Your logo - will need to work up to 200px',
        example: '/assets/example_logo.png',
        example_elem: 'img',
        example_attr: 'src',
        example_props: { width: '120px' },
        element: 'ImageComponent',
        name: 'about_us_logo'
      }
      this.setUpComponent(FieldFormRow, props)
    })

    it('renders the example elem', function() {
      expect(this.dom.querySelector('img')).not.toEqual(null)
    })

    it('renders the drop zone', function() {
      expect(this.dom.querySelector('div.dz-clickable')).not.toEqual(null)
    })

  })
})

