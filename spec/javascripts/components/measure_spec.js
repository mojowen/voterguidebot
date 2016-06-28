describe('Measure', function() {
  beforeEach(function() {
    this.props = {
      id: 5,
      title: 'This Contest',
      description: 'Mike Well Made It',
      yes_means: 'Free cake',
      no_means: 'Paid cake'
    }
    this.setUpComponent(Measure, this.props)
  })

  it('title set by props', function() {
    expect(this.dom.querySelector('[name=title]').value).toEqual(this.props.title)
    expect(this.component.state.changed).toEqual(false)
  })
  it('title updates when changed', function() {
    this.component.handleChange({ target: { name: 'title', value: 'New Title'}})
    expect(this.component.state.title).toEqual('New Title')
    expect(this.component.state.changed).toEqual(true)
  })

  it('yes_means set by props', function() {
    expect(this.dom.querySelector('[name=yes_means]').value).toEqual(this.props.yes_means)
  })
  it('yes_means updates when changed', function() {
    this.component.handleChange({ target: { name: 'yes_means', value: 'New description'}})
    expect(this.component.state.yes_means).toEqual('New description')
    expect(this.component.state.changed).toEqual(true)
  })

  it('no_means set by props', function() {
    expect(this.dom.querySelector('[name=no_means]').value).toEqual(this.props.no_means)
  })
  it('no_means updates when changed', function() {
    this.component.handleChange({ target: { name: 'no_means', value: 'New description'}})
    expect(this.component.state.no_means).toEqual('New description')
    expect(this.component.state.changed).toEqual(true)
  })

  describe('tracks endorsements', function(){
    beforeEach(function() {
      this.against_endorsement = {
        endorser: 'this mook',
        stance: 'against'
      }
      this.for_endorsement = {
        endorser: 'Cowyboy Guy',
        stance: 'for'
      }
      this.endorsements = [this.for_endorsement, this.against_endorsement]
      this.props = {
        id: 5,
        endorsements: this.endorsements
      }
      this.setUpComponent(Measure, this.props)
    })

    it('loads the for endorsments', function() {
      var dom = ReactDOM.findDOMNode(this.component.refs.yes_endorsements)
      expect(dom.querySelectorAll('ul li').length).toEqual(1)
    })
    it('loads the for endorsments', function() {
      var dom = ReactDOM.findDOMNode(this.component.refs.no_endorsements)
      expect(dom.querySelectorAll('ul li').length).toEqual(1)
    })

    it('handles adding endorsers', function() {
      this.component.refs.yes_endorsements.addEndorsement({ preventDefault: function() { }})
      expect(this.component.state.endorsements.reverse()[0]).toEqual(
        { endorser: '', stance: 'for', endorsed_type: 'measure', endorsed_id: this.props.id })
    })
    it('handles change to endorsers', function() {
      var elem = this.dom.querySelector('ul input')
      elem.value = 'Diff Endorser'
      this.component.refs.yes_endorsements.handleChange({ target: elem })
      expect(this.component.state.endorsements[0]).toEqual({ endorser: 'Diff Endorser', stance: 'for' })
    })
    it('handles remove endorsers', function(){
      var event = { currentTarget: this.dom.querySelector('ul .remove'),
                    preventDefault: function() { } }
      this.component.refs.yes_endorsements.removeEndorsement(event)
      expect(this.component.state.endorsements).toEqual([this.against_endorsement])
    })
  })
})

