import { useMemo } from 'react';
import katex from 'katex';
import 'katex/dist/katex.min.css';

interface MathTextProps {
  children: string;
}

function escapeHtml(text: string): string {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function renderLatex(text: string): string {
  const parts: string[] = [];
  let inMath = false;
  let start = 0;

  for (let i = 0; i < text.length; i++) {
    if (text[i] === '$') {
      if (inMath) {
        const math = text.slice(start, i);
        try {
          parts.push(katex.renderToString(math, { displayMode: false }));
        } catch {
          parts.push(escapeHtml(math));
        }
        inMath = false;
        start = i + 1;
      } else {
        parts.push(escapeHtml(text.slice(start, i)));
        start = i + 1;
        inMath = true;
      }
    }
  }

  parts.push(escapeHtml(text.slice(start)));

  return parts.join('');
}

export default function MathText({ children }: MathTextProps) {
  const html = useMemo(() => {
    if (!children) return '';
    return renderLatex(children);
  }, [children]);

  if (!html) return null;

  return <span dangerouslySetInnerHTML={{ __html: html }} />;
}
