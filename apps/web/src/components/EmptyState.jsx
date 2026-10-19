import React from 'react';
import { Inbox } from 'lucide-react';

export const EmptyState = ({
  icon: Icon = Inbox,
  title = 'Nothing here yet',
  description,
  actionLabel,
  onAction,
}) => (
  <div className="flex flex-col items-center justify-center gap-3 py-12 px-4 text-center">
    <div className="rounded-full bg-slate-800 p-4">
      <Icon className="h-8 w-8 text-slate-400" aria-hidden="true" />
    </div>
    <h3 className="text-sm font-semibold text-slate-200">{title}</h3>
    {description ? (
      <p className="max-w-sm text-xs text-slate-400">{description}</p>
    ) : null}
    {actionLabel && onAction ? (
      <button
        type="button"
        onClick={onAction}
        className="mt-1 rounded-lg bg-indigo-600 hover:bg-indigo-500 px-3 py-1.5 text-xs font-semibold text-white"
      >
        {actionLabel}
      </button>
    ) : null}
  </div>
);
