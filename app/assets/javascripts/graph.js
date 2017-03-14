// Responsible for graph animation.
var renderer;
// The graph itself.
var graph;

// First method to be called.
function initialize_graph() {
  var graphics = Viva.Graph.View.svgGraphics();
  graphics.node(nodeLayout)
    .placeNode(placeNodeWithTransform);
  graphics.link(linkLayout)
    .placeLink(placeLink);

  graph = Viva.Graph.graph();

  renderer = Viva.Graph.View.renderer(graph, {
    graphics: graphics,
    container: document.getElementById('graph-container')
  });

  renderer.run();
}

function nodeLayout(node) {
  var data = node.data;

  var radius = 20;
  var ui = Viva.Graph.svg('g');

  var text_ui = Viva.Graph.svg('text')
    .attr('y', '-25px')
    .attr('width','20');

  var span_ui = Viva.Graph.svg('tspan')
    .attr("x","-25px")
    .attr("dy","1.2em")
    .text(data.user.name + " #" + data.question.title);

  var circle = Viva.Graph.svg('circle')
    .attr('cx', radius)
    .attr('cy', radius)
    .attr('fill', 'green')
    .attr('r', radius)
    .attr('id', 'node_n')

  $(circle).dblclick(function(){
    /*$(this).attr('fill', setNodeCollor(node.data.correct, true));
    $.ajax({
       type: "GET",
       url: 'node',
       dataType: 'script',
       data: { answer: node.data, node_html_id: $(this).attr('id') }
     });*/
  });

  $(circle).click(function() {
    /*if (selecting_nodes) {
      $(this).attr('fill', setNodeCollor(node.data.correct, true));
      if (selected_nodes[0] == undefined)
        selected_nodes[0] = node;
      else if (selected_nodes[1] == undefined && node != selected_nodes[0]) {
        selected_nodes[1] = node;
        // The link is displayed only if the graph animation is activated once again.
        informGraphPage();
        addLink();
        resetNodeSelection();
      }
    }*/
  });

  text_ui.append(span_ui);
  ui.append(text_ui);
  ui.append(circle);

  return ui;
}

// Link layout design.
function linkLayout(link) {
  var ui = Viva.Graph.svg('path')
    .attr('stroke', 'black')
    .attr('stroke-width', 5)
    .attr('id', 'link-x');

  $(ui).dblclick(function() {
    $(this).attr('stroke', 'yellow');
    /*$.ajax({
       type: "GET",
       url: 'link',
       dataType: 'script',
       data: { link_html_id: $(this).attr('id'),
               answer_1: link.data.answer_1,
               answer_2: link.data.answer_2
             }
     });*/
  });

  return ui;
}

// Node position.
function placeNodeWithTransform(nodeUI, pos) {
  nodeUI.attr('transform', 'translate(' + (pos.x - 12) + ',' + (pos.y - 12) + ')');
}

// Link position.
function placeLink(linkUI, fromPos, toPos) {
  var data = 'M' + (fromPos.x + 10) + ',' + (fromPos.y + 10) +
             'L' + (toPos.x + 10) + ',' + (toPos.y + 10);
  linkUI.attr("d", data);
}

function getAlreadyDisplaiedAnswers() {
  var answer_ids = [];

  graph.forEachNode(function(node) {
    answer_ids[answer_ids.length] = node.data.id
  });

  return answer_ids
}

function addAnswer(id, object) {
  var answers_ids = getAlreadyDisplaiedAnswers();

  $.ajax({
     type: "GET",
     url: 'connections',
     dataType: 'json',
     data: { answers: answers_ids,
             target_answer: id
           },
     success: function(connections) {
          if (connections.length > 0) {
            for (i = 0; i < connections.length; i++) {
              connection = connections[i];

              answer_1 = graph.addNode(connection.answer_1.id,
                                       connection.answer_1);
              answer_2 = graph.addNode(connection.answer_2.id,
                                       connection.answer_2);
              graph.addLink(connection.answer_1.id, connection.answer_2.id)
            }
          } else {
            graph.addNode(id, object);
          }
      }
  });
}


// Pause the graph animation.
function pause() {
  renderer.pause();
}

// Resume the graph animation.
function resume() {
  renderer.resume();
}
