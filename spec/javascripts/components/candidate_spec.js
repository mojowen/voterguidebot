describe('Candidate', function() {
  beforeEach(function() {
    this.props = {
      id: 5,
      name: 'Billy Bob',
      party: 'Democrat',
      bio: 'Dated Angelina Jolie',
      photo: '/smiling-guy',
      twitter: 'Twitter',
      website: 'Website',
      facebook: 'Facebook',
      endorsements: [{ endorser: 'Cowyboy Guy', stance: 'for' }],
      handleChange: function() { },
      handleRemove: function() { },
    }
    spyOn(this.props, 'handleChange')
    spyOn(this.props, 'handleRemove')
    this.setUpComponent(Candidate, this.props)
  })

  it('initializes name', function() {
    var input = this.dom.querySelector('[name=name]')
    expect(input.value).toEqual(this.props.name)
  })
  it('handles change to name', function() {
    this.component.handleChange({ target: { name: 'name', value: 'New Name'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'name', 'New Name')
  })

  it('initializes party', function() {
    var input = this.dom.querySelector('[name=party]')
    expect(input.value).toEqual(this.props.party)
  })
  it('handles change to party', function() {
    this.component.handleChange({ target: { name: 'party', value: 'Republican'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'party', 'Republican')
  })

  it('initializes bio', function() {
    var input = this.dom.querySelector('[name=bio]')
    expect(input.value).toEqual(this.props.bio)
  })
  it('handles change to bio', function() {
    this.component.handleChange({ target: { name: 'bio', value: 'New bio'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'bio', 'New bio')
  })

  it('initializes facebook', function() {
    var input = this.dom.querySelector('[name=facebook]')
    expect(input.value).toEqual(this.props.facebook)
  })
  it('handles change to facebook', function() {
    this.component.handleChange({ target: { name: 'facebook', value: 'New facebook'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'facebook', 'New facebook')
  })

  it('initializes website', function() {
    var input = this.dom.querySelector('[name=website]')
    expect(input.value).toEqual(this.props.website)
  })
  it('handles change to website', function() {
    this.component.handleChange({ target: { name: 'website', value: 'New website'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'website', 'New website')
  })

  it('initializes twitter', function() {
    var input = this.dom.querySelector('[name=twitter]')
    expect(input.value).toEqual(this.props.twitter)
  })
  it('handles change to twitter', function() {
    this.component.handleChange({ target: { name: 'twitter', value: 'New twitter'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'twitter', 'New twitter')
  })

  it('initializes photo', function() {
    expect(this.dom.querySelector('img').getAttribute('src')).toEqual(this.props.photo)
  })
  it('handles change to photo', function() {
    this.component.handleChange({ target: { name: 'photo', value: '/new/photo'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'photo', '/new/photo')
  })

  it('handles adding endorsers', function() {
    this.component.refs.endorsements.addEndorsement({ preventDefault: function() { }})
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'endorsements',
      [
        { endorser: 'Cowyboy Guy', stance: 'for', },
        { endorser: '',
          stance: 'for',
          endorsed_type: 'candidate',
          endorsed_id: this.props.id }])
  })
  it('handles change to endorsers', function() {
    var elem = this.dom.querySelector('ul input')
    elem.value = 'Diff Endorser'
    this.component.refs.endorsements.handleChange({ target: elem })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'endorsements', [{ endorser: 'Diff Endorser', stance: 'for' }])
  })
  it('handles remove endorsers', function(){
    var event = { currentTarget: this.dom.querySelector('ul .remove'),
                  preventDefault: function() { } }
    this.component.refs.endorsements.removeEndorsement(event)
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'endorsements', [])
  })

  it('handles removal', function() {
    this.component.handleRemove({})
    expect(this.component.props.handleRemove).toHaveBeenCalledWith(this.props.id)
  })
})

