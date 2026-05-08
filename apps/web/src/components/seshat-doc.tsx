import ReactMarkdown, { type Components } from "react-markdown";
import remarkGfm from "remark-gfm";
import rehypeSlug from "rehype-slug";

const components: Components = {
  h1: ({ node: _node, ...props }) => <h1 className="seshat-doc-h1" {...props} />,
  h2: ({ node: _node, ...props }) => <h2 className="seshat-doc-h2" {...props} />,
  h3: ({ node: _node, ...props }) => <h3 className="seshat-doc-h3" {...props} />,
  h4: ({ node: _node, ...props }) => <h4 className="seshat-doc-h4" {...props} />,
  h5: ({ node: _node, ...props }) => <h5 className="seshat-doc-h5" {...props} />,
  h6: ({ node: _node, ...props }) => <h6 className="seshat-doc-h6" {...props} />,
  p: ({ node: _node, ...props }) => <p className="seshat-doc-p" {...props} />,
  a: ({ node: _node, href, children, ...rest }) => (
    <a
      className="seshat-doc-link"
      href={href}
      target={href?.startsWith("http") ? "_blank" : undefined}
      rel={href?.startsWith("http") ? "noopener noreferrer" : undefined}
      {...rest}
    >
      {children}
    </a>
  ),
  ul: ({ node: _node, ...props }) => <ul className="seshat-doc-ul" {...props} />,
  ol: ({ node: _node, ...props }) => <ol className="seshat-doc-ol" {...props} />,
  li: ({ node: _node, ...props }) => <li className="seshat-doc-li" {...props} />,
  blockquote: ({ node: _node, ...props }) => (
    <blockquote className="seshat-doc-blockquote" {...props} />
  ),
  hr: () => <hr className="seshat-doc-hr" />,
  pre: ({ node: _node, ...props }) => <pre className="seshat-doc-pre" {...props} />,
  code: ({ node: _node, className, children, ...rest }) => {
    const isBlock = /language-/.test(className ?? "");
    if (isBlock) {
      return (
        <code className={`seshat-doc-code-block ${className ?? ""}`} {...rest}>
          {children}
        </code>
      );
    }
    return (
      <code className="seshat-doc-code-inline" {...rest}>
        {children}
      </code>
    );
  },
  table: ({ node: _node, ...props }) => (
    <div className="seshat-doc-table-wrap">
      <table className="seshat-doc-table" {...props} />
    </div>
  ),
  thead: ({ node: _node, ...props }) => <thead className="seshat-doc-thead" {...props} />,
  tbody: ({ node: _node, ...props }) => <tbody {...props} />,
  tr: ({ node: _node, ...props }) => <tr className="seshat-doc-tr" {...props} />,
  th: ({ node: _node, ...props }) => <th className="seshat-doc-th" {...props} />,
  td: ({ node: _node, ...props }) => <td className="seshat-doc-td" {...props} />,
  img: ({ node: _node, alt, src, ...rest }) => (
    // eslint-disable-next-line @next/next/no-img-element
    <img className="seshat-doc-img" alt={alt ?? ""} src={src as string} {...rest} />
  ),
  input: ({ node: _node, type, checked, ...rest }) => {
    if (type === "checkbox") {
      return (
        <span
          className={`seshat-doc-task ${checked ? "is-checked" : ""}`}
          aria-hidden="true"
        >
          {checked ? (
            <svg viewBox="0 0 12 12" width="9" height="9" fill="none">
              <path
                d="M2 6.4 L4.7 9 L10 3"
                stroke="currentColor"
                strokeWidth="1.6"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
            </svg>
          ) : null}
        </span>
      );
    }
    return <input type={type} {...rest} />;
  },
};

type Props = {
  content: string;
};

export function SeshatDoc({ content }: Props) {
  return (
    <article className="seshat-doc">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        rehypePlugins={[rehypeSlug]}
        components={components}
      >
        {content}
      </ReactMarkdown>
    </article>
  );
}
