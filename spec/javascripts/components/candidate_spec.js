describe('Candidate', function() {
  beforeEach(function() {
    this.props = {
      id: 5,
      name: 'Billy Bob',
      bio: 'Dated Angelina Jolie',
      photo: '/smiling-guy',
      twitter: 'Twitter',
      website: 'Website',
      facebook: 'Facebook',
      endorsements: ['Cowyboy Guy'],
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
    expect(input.name).toEqual('name')
  })
  it('handles change to name', function() {
    this.component.handleChange({ target: { name: 'name', value: 'New Name'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'name', 'New Name')
  })

  it('initializes bio', function() {
    var input = this.dom.querySelector('[name=bio]')
    expect(input.value).toEqual(this.props.bio)
    expect(input.name).toEqual('bio')
  })
  it('handles change to bio', function() {
    this.component.handleChange({ target: { name: 'bio', value: 'New bio'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'bio', 'New bio')
  })

  it('initializes facebook', function() {
    var input = this.dom.querySelector('[name=facebook]')
    expect(input.value).toEqual(this.props.facebook)
    expect(input.name).toEqual('facebook')
  })
  it('handles change to facebook', function() {
    this.component.handleChange({ target: { name: 'facebook', value: 'New facebook'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'facebook', 'New facebook')
  })

  it('initializes website', function() {
    var input = this.dom.querySelector('[name=website]')
    expect(input.value).toEqual(this.props.website)
    expect(input.name).toEqual('website')
  })
  it('handles change to website', function() {
    this.component.handleChange({ target: { name: 'website', value: 'New website'} })
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'website', 'New website')
  })

  it('initializes twitter', function() {
    var input = this.dom.querySelector('[name=twitter]')
    expect(input.value).toEqual(this.props.twitter)
    expect(input.name).toEqual('twitter')
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
    this.component.addEndorsement({ preventDefault: function() { }})
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'endorsements', ['Cowyboy Guy', null])
  })
  it('handles change to endorsers', function() {
    var event = { target: { name: 'endorsement_0', value: 'Diff Endorser'} }
    this.component.handleChange(event)
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'endorsements', ['Diff Endorser'])
  })
  it('handles remove endorsers', function(){
    var event = { target: this.dom.querySelector('ul .remove'),
                  preventDefault: function() { } }
    this.component.removeEndorsement(event)
    expect(this.component.props.handleChange).toHaveBeenCalledWith(
      this.props.id, 'endorsements', [])
  })

  it('handles removal', function() {
    this.component.handleRemove({})
    expect(this.component.props.handleRemove).toHaveBeenCalledWith(this.props.id)
  })
})

