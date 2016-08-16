ReportTab = require 'reportTab'
templates = require '../templates/templates.js'
d3 = window.d3

_partials = require '../node_modules/seasketch-reporting-api/templates/templates.js'
partials = []
for key, val of _partials
  partials[key.replace('node_modules/seasketch-reporting-api/', '')] = val


class OverviewTab extends ReportTab
  name: 'Overview'
  className: 'overview'
  template: templates.overview
  dependencies:[ 
    'MarcoHabitat',
    'SizeToolbox'
  ]

  render: () ->

    habitats = @recordSet('MarcoHabitat', 'MarcoHabitats').toArray()
    @roundData habitats
    habitats = _.sortBy habitats, (row) -> row.Name
    size = @recordSet('SizeToolbox', 'Size').float('Size')

    # setup context object with data and render the template from it
    context =
      sketch: @model.forTemplate()
      sketchClass: @sketchClass.forTemplate()
      attributes: @model.getAttributes()
      admin: @project.isAdmin window.user
      size:size
      habitats: habitats
    
    @$el.html @template.render(context, templates)
    @enableLayerTogglers()
    @enableTablePaging()

  roundData: (data) =>
    for d in data
      try
        d.AREA = parseFloat(d.AREA).toFixed(1)
      catch
        d.AREA = 0.0

module.exports = OverviewTab