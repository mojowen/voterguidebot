describe('Candidate', function() {
  beforeEach(function() {
    this.candidate = {
      id: 5,
      name: 'Billy Bob',
      party: 'Democrat',
      bio: 'Dated Angelina Jolie',
      photo: '/smiling-guy',
      twitter: 'Twitter',
      website: 'Website',
      facebook: 'Facebook',
      endorsements: [{ endorser: 'Cowyboy Guy', stance: 'for' }]
    }

    this.props = _.defaults(this.candidate, {
      index: 0,
      candidates: [this.candidate],
      handleChange: function() { },
    })

    spyOn(this.props, 'handleChange')
    this.setUpComponent(Candidate, this.props)
    this.component.setState({ open: true })
  })

  it('initializes name', function() {
    var input = this.dom.querySelector('[name=name]')
    expect(input.value).toEqual(this.props.name)
  })
  it('handles change to name', function() {
    this.component.handleChange({ target: { name: 'name', value: 'New Name'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      'candidates', [_.defaults(this.candidate, { name: 'New Name' })])
  })

  it('initializes party', function() {
    var input = this.dom.querySelector('[name=party]')
    expect(input.value).toEqual(this.props.party)
  })
  it('handles change to party', function() {
    this.component.handleChange({ target: { name: 'party', value: 'Republican'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      'candidates', [_.defaults(this.candidate, { party: 'Republican' })])
  })

  it('initializes bio', function() {
    var input = this.dom.querySelector('[name=bio]')
    expect(input.value).toEqual(this.props.bio)
  })
  it('handles change to bio', function() {
    this.component.handleChange({ target: { name: 'bio', value: 'New bio'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      'candidates', [_.defaults(this.candidate, { bio: 'New bio' })])
  })

  it('initializes facebook', function() {
    var input = this.dom.querySelector('[name=facebook]')
    expect(input.value).toEqual(this.props.facebook)
  })
  it('handles change to facebook', function() {
    this.component.handleChange({ target: { name: 'facebook', value: 'New facebook' } })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      'candidates', [_.defaults(this.candidate, { facebook: 'New facebook' })])
  })

  it('initializes website', function() {
    var input = this.dom.querySelector('[name=website]')
    expect(input.value).toEqual(this.props.website)
  })
  it('handles change to website', function() {
    this.component.handleChange({ target: { name: 'website', value: 'New website' } })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      'candidates', [_.defaults(this.candidate, { website: 'New website' })])
  })

  it('initializes twitter', function() {
    var input = this.dom.querySelector('[name=twitter]')
    expect(input.value).toEqual(this.props.twitter)
  })
  it('handles change to twitter', function() {
    this.component.handleChange({ target: { name: 'twitter', value: 'New twitter' } })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      'candidates', [_.defaults(this.candidate, { twitter: 'New twitter' })])
  })

  it('initializes photo', function() {
    expect(this.dom.querySelector('div.img').style.backgroundImage).toMatch(this.props.photo)
  })
  it('handles change to photo', function() {
    this.component.handleChange({ target: { name: 'photo', value: '/new/photo' } })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      'candidates', [_.defaults(this.candidate, { photo: '/new/photo' })])
  })
  it('hold open disables button to close', function() {
    this.component.holdOpen()
    expect(this.component.state.disable_close).toEqual(true)
    expect(this.dom.querySelector('button').getAttribute('disabled')).toEqual('')
  })
  it('release hold on handleUpload', function() {
    var event = { target: { name: 'photo', value: '/new/photo' } }
    this.component.setState({ disable_close: true })
    spyOn(this.component, 'handleChange')
    this.component.handleUpload(event)
    expect(this.component.state.disable_close).toEqual(false)
    expect(this.dom.querySelector('button').getAttribute('disabled')).toEqual(null)
    expect(this.component.handleChange).toHaveBeenCalledWith(event)
  })

  it('handles adding endorsers', function() {
    this.component.refs.endorsements.addEndorsement({ preventDefault: function() { }})
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      'candidates', [_.defaults(this.candidate, { endorsements: [
        { endorser: 'Cowyboy Guy', stance: 'for', },
        { endorser: '',
          stance: 'for',
          endorsed_type: 'candidate',
          endorsed_id: this.props.id }] })])
  })
  it('handles change to endorsers', function() {
    var elem = this.dom.querySelector('ul input')
    elem.value = 'Diff Endorser'
    this.component.refs.endorsements.handleChange({ target: elem })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
    'candidates', [_.defaults(this.candidate, { endorsements: [
      { endorser: 'Diff Endorser', stance: 'for' }] })])
  })
  it('handles remove endorsers', function(){
    var event = { currentTarget: this.dom.querySelector('ul .remove'),
                  preventDefault: function() { } }
    this.component.refs.endorsements.removeEndorsement(event)
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
    'candidates', [_.defaults(this.candidate, { endorsements: [] })])
  })
  it('handles removal', function() {
    this.component.handleRemove({ preventDefault: function() { } })
    swalSpy.confirmLast(true)
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      'candidates', [])
  })

  describe('with two candidates', function() {
      beforeEach(function() {
        this.candidate = {}
        this.other_candidate = {}

        this.props = {
          index: 0,
          candidates: [this.candidate, this.other_candidate],
          handleChange: function() { },
        }

        spyOn(this.props, 'handleChange')
        this.setUpComponent(Candidate, this.props)
      })
    it('handleDragOver reorders the candidates', function() {
      this.component.handleDragOver(0, 1)
      expect(this.component.props.handleChange).toHaveBeenCalledWith(
        'candidates', [this.other_candidate, this.candidate])
    })
  })
})

