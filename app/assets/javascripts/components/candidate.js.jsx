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

    this.props.handleChange(this.props.id, field, value)
  },
  handleEndorsementChange: function(field, value) {
    this.props.handleChange(this.props.id, field, value)
  },
  handleRemove: function(event) {
    this.props.handleRemove(this.props.id)
  },
  render: function() {
    return <div className="candidate--form mui-col-md-5 mui-col-md-offset-1 mui-panel">
      <i className="fa fa-times remove--candidate" onClick={ this.handleRemove } />
      <InputComponent label="photo"
                      element="ImageComponent"
                      value={this.props.photo}
                      name="photo"
                      preview={true}
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
                        value={this.props.website} name="website" type="url"
                        onChange={this.handleChange} fa="link" />
        <InputComponent placeholder="http://facebook.com/candidate-name"
                        value={this.props.facebook} name="facebook" type="url"
                        onChange={this.handleChange} fa="facebook-square" />
        <InputComponent placeholder="http://twitter.com/the-real-candidate"
                        value={this.props.twitter} name="twitter" type="url"
                        onChange={this.handleChange} fa="twitter-square" />
      </div>
      <Endorsements ref="endorsements"
                    endorsements={this.props.endorsements}
                    handleChange={this.handleEndorsementChange}
                    endorsed_type='candidate'
                    endorsed_id={this.props.id} />
    </div>
  }
})
