describe('Candidate', function() {
  beforeEach(function() {
    this.props = {
      name: 'Billy Bob',
      bio: 'Dated Angelina Jolie',
      photo: '/smiling-guy',
      endorsements: ['Cowyboy Guy'],
      handleChange: function() { },
      handleRemove: function() { },
    }
    spyOn(this.props, 'handleChange')
    spyOn(this.props, 'handleRemove')
    this.setUpComponent(Candidate, this.props)
  })

  it('initializes name')
  it('initializes photo')
  it('initializes bio')
  it('initializes facebook')
  it('initializes website')
  it('initializes twitter')

  it('handles change to name')
  it('handles change to photo')
  it('handles change to endorsers')
  it('handles adding endorsers')
  it('handles change to facebook')
  it('handles change to website')
  it('handles change to twitter')
  it('handles change to bio')
  it('handles removal')
})

