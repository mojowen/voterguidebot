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
      return <td key={candidate.id}><div className="mui-select">
          <select name={candidate.id} value={this.props[candidate.id]} onChange={this.handleChange} >
            <option value="N/A">N/A</option>
            <option value="Yes">Yes</option>
            <option value="No">No</option>
          </select>
        </div></td>
    }, this),
      after = <a className="remove" onClick={this.handleRemove} >
          <i className="fa fa-times" />
        </a>

    return <tr>
      <td className="question">
        <InputComponent value={this.props.text}
                        name="text"
                        placeholder="Add Your Question"
                        handleChange={this.handleChange}
                        afterLabel={after} />
        </td>
      { candidates }
    </tr>
  }
})
