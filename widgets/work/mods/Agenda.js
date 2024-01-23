import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js'
import { AgendaText } from '../../../variables.js';

function parseMarkdown(markdownText) {
  function parseLine(text) {
    const blocks = [];

    function parseText(text) {
      let match;

      match = text.match(/^(#{1,6})\s(.+)$/);
      if (match) {
        const level = match[1].length;
        blocks.push({ type: `heading-${level}`, content: match[2].trim() });
        const remainingText = text.substring(match[0].length);
        parseText(remainingText);
        return;
      }

      // Check for single line code
      match = text.match(/`([^\`]+)`/);
      if (match) {
        blocks.push({ type: 'code', content: match[1] });
        const remainingText = text.substring(match[0].length);
        parseText(remainingText);
        return;
      }

      // Check for bold
      match = text.match(/^\*\*([^*]+)\*\*/);
      if (match) {
        blocks.push({ type: 'bold', content: match[1] + " " });
        const remainingText = text.substring(match[0].length);
        parseText(remainingText);
        return;
      }

      // Check for italics
      match = text.match(/^_([^_]+)_/);
      if (match) {
        blocks.push({ type: 'italic', content: match[1] + " " });
        const remainingText = text.substring(match[0].length);
        parseText(remainingText);
        return;
      }

      // Check for both italics and bold
      match = text.match(/^\^([^^]+)\^/);
      if (match) {
        blocks.push({ type: 'italic-bold', content: match[1] + " " });
        const remainingText = text.substring(match[0].length);
        parseText(remainingText);
        return;
      }

      // Check for todos
      match = text.match(/^- \[([ Xx])\](.+)/);
      if (match) {
        blocks.push({
          type: 'todo',
          completed: match[1].toLowerCase() === 'x',
          content: match[2].trim() + " ",
        });
        const remainingText = '';
        parseText(remainingText);
        return;
      }

      // Check for lists
      match = text.match(/^\+ (.+)/);
      if (match) {
        blocks.push({ type: 'list', content: match[1].trim() + " " });
        const remainingText = '';
        parseText(remainingText);
        return;
      }

      // Check for links
      match = text.match(/(\[([^\]]+)\]\(([^)]+)\))/);
      if (match) {
        const beforeText = match.index > 0 ? text.substring(0, match.index) : '';
        if (beforeText) {
          blocks.push({ type: 'text', content: beforeText });
        }

        blocks.push({ type: 'link', content: match[2], url: match[3] });

        const remainingText = text.substring(match.index + match[0].length);
        parseText(remainingText);
        return;
      }


      // Check for text without markup
      match = text.match(/^([^_*]+)(?=[_*\^]|^- \[ \]|\+)/);
      if (match) {
        blocks.push({ type: 'text', content: match[1].trim() + " " });
        const remainingText = text.substring(match[1].length);
        parseText(remainingText);
        return;
      }

      // Handle the case where the remaining text doesn't match any pattern
      if (text.length > 0) {
        blocks.push({ type: 'text', content: text.trim() + " " });
      }
    }

    parseText(text);

    return blocks;
  }

  const lines = markdownText.split('\n');
  const parsedLines = [];

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const blocks = parseLine(line);
    parsedLines.push(blocks);
  }

  return parsedLines;
}

export default () => Widget.Box({
  class_name: 'work-agenda',
  vertical: true,
  spacing: 5,
  children: [
    Widget.Box({ spacing: 5, children: [Widget.Button({ on_clicked: () => { Utils.execAsync('wezterm start --always-new-process -e sh -c "nvim ~/.config/ags/_data/agenda.md" &') }, child: Widget.Label({ class_name: "icon", label: "󰏫" }) }), Widget.Label({ label: "Agenda", hpack: "start", class_name: "work-agenda-title" })] }),
    Widget.Scrollable({
      vscroll: 'always',
      hscroll: 'never',
      vexpand: true,
      class_name: 'work-agenda-scroll',
      child: Widget.Box({
        vertical: true,
        spacing: 5,
        setup: (self) => {
          self.hook(AgendaText, (self) => {
            const content = parseMarkdown(AgendaText.value)
            console.log(content)
            self.children = content.map(e => {
              if (e == []) {
                return Widget.Box({ css: `margin: 16px;` })
              }
              return Widget.Box({
                children: e.map(i => {
                  const type = i.type
                  if (type == "link") {
                    return Widget.Button({
                      class_name: `work-agenda-${i.type}`,
                      label: i.content,
                      on_clicked: () => {
                        Utils.exec(`firefox ${i.url}`)
                      }
                    })
                  } else if (type == "todo") {
                    return Widget.Box({
                      spacing: 5,
                      children: [
                        Widget.Box({
                          class_names: ['icon', `work-agenda-todo-${i.completed}`],
                          vpack: "center",
                        }),
                        Widget.Label({
                          label: i.content,
                          class_name: `work-agenda-text-${i.completed}`
                        }),
                      ]
                    })
                  } else if (type == "list") {
                    return Widget.Box({
                      spacing: 5,
                      children: [
                        Widget.Box({
                          class_names: ['icon', `work-agenda-list`],
                          vpack: "center",
                        }),
                        Widget.Label({
                          label: i.content,
                        }),
                      ]
                    })
                  }
                  return Widget.Label({ label: i.content, class_name: `work-agenda-${type}` })
                })
              })
            }
            )
          })
        }
      }),
    })
  ],
})
