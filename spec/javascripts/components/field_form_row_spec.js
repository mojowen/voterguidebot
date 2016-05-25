describe('FieldFormRow', function() {

  beforeEach(function() {
    var props = {
      name: 'Great Field',
      element: 'textarea',
      example: '2016 Denver Voter Guide',
      limit: 40,
      id: 'title_page_subheader'
    }
    this.setUpComponent(FieldFormRow, props)
  })

  it('creates inputs for the guides', function() {
    expect(this.dom.querySelectorAll('textarea').length).toEqual(1)
  })

  it('shows remaining characters', function() {
    var typed = 'what what what'
    this.component.updateValue(typed)
    expect(parseInt(this.component.refs.remaining.innerText)).toEqual(
      this.component.props.limit - typed.length)
  })

  it('renders the previews', function() {
    this.component.updateValue('update_preview')
    expect(this.component.refs.preview.innerText).toEqual('update_preview')
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

