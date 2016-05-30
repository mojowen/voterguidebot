var Candidate = React.createClass({
  getDefaultProps: function() {
    return { name: '',
             bio: '',
             photo: '',
             id: '',
             endorsements: [],
             handleChange: function() { },
             handleRemove: function() { } }
  },
  handleChange: function(event) {
    var field = event.target.name,
        value = event.target.value

    if( field.match(/endorsement/) ) {
      var value = this.props.endorsements
      value[ parseInt(field.split('_')[1]) ] = event.target.value
      field = 'endorsements'
    }

    this.props.handleChange(this.props.id, field, value)
  },
  handleRemove: function(event) {
    this.props.handleRemove(this.props.id)
  },
  addEndorsement: function(event) {
    var endorsements = this.props.endorsements
    if( endorsements.length < 3 ) endorsements.push(null)
    this.props.handleChange(this.props.id, 'endorsements', endorsements)
    event.preventDefault()
  },
  removeEndorsement: function(event) {
    var endorsements = _.without(this.props.endorsements,
                                 event.currentTarget.getAttribute('data-endorsement'))
    this.props.handleChange(this.props.id, 'endorsements', endorsements)
    event.preventDefault()
  },
  render: function() {
    var endorsements = _.map(this.props.endorsements, function(endorsement, index) {
          var after = <a className="remove" onClick={this.removeEndorsement} data-endorsement={endorsement} >
                        <i className="fa fa-times" />
                      </a>
          return <li key={'endorsement_'+index} >
                  <InputComponent value={endorsement}
                                  name={'endorsement_'+index}
                                  onChange={this.handleChange}
                                  after={after} />
                 </li>
        }, this),
        addEndorsement = ''
    if( this.props.endorsements.length < 3 ) {
      addEndorsement = <a className="add--endorsements" onClick={this.addEndorsement}><i className="fa fa-plus-square" /></a>
    }

    return <div className="candidate--form mui-col-md-5 mui-panel">
      <i className="fa fa-times remove--candidate" onClick={ this.handleRemove } />
      <InputComponent label="photo"
                      element="ImageComponent"
                      value={this.props.photo}
                      name="photo"
                      onChange={this.handleChange} />

      <InputComponent label="Name"
                      placeholder="Joe Smith"
                      value={this.props.name}
                      name="name"
                      onChange={this.handleChange} />
      <InputComponent label="Bio"
                      placeholder="Paper towel preserver, motorcycle rider, etc."
                      value={this.props.bio}
                      element="textarea"
                      name="bio"
                      onChange={this.handleChange} />
      <strong>Links</strong>
      <div className="social">
        <InputComponent placeholder="http://candidate-website.pizza"
                        value={this.props.website} name="website"
                        onChange={this.handleChange} fa="link" />
        <InputComponent placeholder="http://facebook.com/candidate-name"
                        value={this.props.facebook} name="facebook"
                        onChange={this.handleChange} fa="facebook-square" />
        <InputComponent placeholder="http://twitter.com/the-real-candidate"
                        value={this.props.twitter} name="twitter"
                        onChange={this.handleChange} fa="twitter-square" />
      </div>
      <div className="endorsements">
        <strong>Endorsements</strong>{ addEndorsement }

        <ul>{ endorsements }</ul>
      </div>
    </div>
  }
})
