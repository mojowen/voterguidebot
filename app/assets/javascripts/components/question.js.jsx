var Question = React.createClass({
  getDefaultProps: function() {
    return { candidates: [],
             text: '',
             id: null,
             handleRemove: function() {  },
             handleChange: function() {  } }
  },
  handleChange: function(event) {
    this.props.handleChange(this.props.id, event.target.name, event.target.value)
  },
  handleRemove: function(event) {
    this.props.handleRemove(this.props.id)
  },
  render: function() {
    var candidates = _.map(this.props.candidates, function(candidate) {
      return <td key={candidate.id}>
              <InputComponent name={candidate.id}
                              value={this.props[candidate.id]}
                              onChange={this.handleChange}
                              placeholder="..." />
            </td>
    }, this)

    return <tr>
      <td>
        <a className="remove" onClick={this.handleRemove} >
          <i className="fa fa-times" />
        </a>
      </td>
      <td className="question">
        <InputComponent value={this.props.text}
                        name="text"
                        placeholder="Add Your Question"
                        handleChange={this.handleChange}
                        />
        </td>
      { candidates }
    </tr>
  }
})
