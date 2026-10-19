import React, { useState } from 'react';
import { PostCard } from './PostCard';
import { DebateModal } from '../debate/DebateModal';
import { PlusCircle, SearchX, Sparkles } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { EmptyState } from '../../components/EmptyState';

const INITIAL_POSTS = [
  {
    id: 'post-1',
    authorId: 'user-1',
    authorName: 'Sarah Jenkins',
    title: 'Monorepos with Turborepo + npm are superior for GDG Fullstack Teams',
    content: 'Managing Flutter mobile apps alongside React web clients and Firebase Cloud Functions in a unified repository drastically reduces integration overhead and makes schema sharing effortless.',
    topic: 'tech',
    tags: ['monorepo', 'flutter', 'react', 'architecture'],
    upvotes: 42,
    downvotes: 3,
    replyCount: 18,
    moderationStatus: 'approved',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  },
  {
    id: 'post-2',
    authorId: 'user-2',
    authorName: 'Priya Sharma',
    title: 'Why GDGOC Sprints should focus on Real-World Open Source tooling',
    content: 'Contributing to live projects during sprints gives students direct experience with CI/CD, branch naming, pull request reviews, and scalable backend security rules.',
    topic: 'open-source',
    tags: ['gdgoc', 'opensource', 'sprint2026'],
    upvotes: 89,
    downvotes: 1,
    replyCount: 24,
    moderationStatus: 'approved',
    createdAt: new Date(Date.now() - 3600000 * 4).toISOString(),
    updatedAt: new Date(Date.now() - 3600000 * 4).toISOString(),
  },
];

export const FeedList = () => {
  const { user } = useAuth();
  const [posts, setPosts] = useState(INITIAL_POSTS);
  const [filter, setFilter] = useState('');
  const [newTitle, setNewTitle] = useState('');
  const [newContent, setNewContent] = useState('');
  const [newTopic, setNewTopic] = useState('tech');
  const [showForm, setShowForm] = useState(false);
  const [activeDebatePost, setActiveDebatePost] = useState(null);

  const handleCreatePost = (e) => {
    e.preventDefault();
    if (!newTitle.trim() || !newContent.trim()) return;

    const newPost = {
      id: `post-${Date.now()}`,
      authorId: user?.uid || 'guest-user',
      authorName: user?.displayName || 'Campus Contributor',
      title: newTitle,
      content: newContent,
      topic: newTopic,
      tags: ['opentalk', newTopic],
      upvotes: 1,
      downvotes: 0,
      replyCount: 0,
      moderationStatus: 'approved',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };

    setPosts([newPost, ...posts]);
    setNewTitle('');
    setNewContent('');
    setShowForm(false);
  };

  const handleVote = (postId, type) => {
    setPosts((prev) =>
      prev.map((p) => {
        if (p.id !== postId) return p;
        return {
          ...p,
          upvotes: type === 'up' ? p.upvotes + 1 : p.upvotes,
          downvotes: type === 'down' ? p.downvotes + 1 : p.downvotes,
        };
      })
    );
  };

  return (
    <div className="space-y-6">
      {/* Create post banner */}
      <div className="p-5 rounded-2xl bg-gradient-to-r from-indigo-900/30 via-slate-900 to-purple-900/30 border border-indigo-500/20">
        {!showForm ? (
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <Sparkles className="w-6 h-6 text-indigo-400" />
              <div>
                <h2 className="text-base font-semibold text-slate-100">Take a Stance</h2>
                <p className="text-xs text-slate-400">Share an opinion, trigger a debate, or start a topic.</p>
              </div>
            </div>
            <button
              onClick={() => setShowForm(true)}
              className="flex items-center space-x-2 px-4 py-2 rounded-xl bg-indigo-600 hover:bg-indigo-500 text-white text-sm font-semibold shadow-lg shadow-indigo-600/30 transition-all"
            >
              <PlusCircle className="w-4 h-4" />
              <span>Share Stance</span>
            </button>
          </div>
        ) : (
          <form onSubmit={handleCreatePost} className="space-y-3">
            <h3 className="text-sm font-semibold text-slate-200">New Stance Post</h3>
            <input
              type="text"
              placeholder="What is your stance title?"
              value={newTitle}
              onChange={(e) => setNewTitle(e.target.value)}
              className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-2 text-sm text-slate-100 placeholder-slate-500 focus:outline-none focus:border-indigo-500"
              required
            />
            <textarea
              placeholder="Elaborate on your stance, arguments, and points..."
              value={newContent}
              onChange={(e) => setNewContent(e.target.value)}
              rows={3}
              className="w-full bg-slate-950 border border-slate-800 rounded-xl px-4 py-2 text-sm text-slate-100 placeholder-slate-500 focus:outline-none focus:border-indigo-500 resize-none"
              required
            />
            <div className="flex items-center justify-between pt-2">
              <select
                value={newTopic}
                onChange={(e) => setNewTopic(e.target.value)}
                className="bg-slate-950 border border-slate-800 text-xs text-slate-300 rounded-lg px-3 py-1.5 focus:outline-none focus:border-indigo-500"
              >
                <option value="tech">Tech & Architecture</option>
                <option value="open-source">Open Source Sprint</option>
                <option value="campus">Campus Hub</option>
                <option value="career">Career & Industry</option>
              </select>
              <div className="flex items-center space-x-2">
                <button
                  type="button"
                  onClick={() => setShowForm(false)}
                  className="px-3 py-1.5 text-xs text-slate-400 hover:text-slate-200"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="px-4 py-1.5 rounded-lg bg-indigo-600 hover:bg-indigo-500 text-white text-xs font-semibold"
                >
                  Publish Stance
                </button>
              </div>
            </div>
          </form>
        )}
      </div>

      {/* Post feed list */}
      <div className="space-y-4">
        <input
          type="search"
          value={filter}
          onChange={(e) => setFilter(e.target.value)}
          placeholder="Filter stances..."
          aria-label="Filter stances"
          className="w-full rounded-lg border border-slate-700 bg-slate-900 px-3 py-2 text-sm text-slate-200 placeholder:text-slate-500 focus:border-indigo-500 focus:outline-none"
        />
        {(() => {
          const q = filter.trim().toLowerCase();
          const visible = q
            ? posts.filter(
                (p) =>
                  (p.title || '').toLowerCase().includes(q) ||
                  (p.content || '').toLowerCase().includes(q) ||
                  (p.topic || '').toLowerCase().includes(q) ||
                  (p.tags || []).some((t) => String(t).toLowerCase().includes(q)),
              )
            : posts;
          if (visible.length === 0) {
            return (
              <EmptyState
                icon={SearchX}
                title="No stances match"
                description="Try different filters, or clear them to see the full feed."
                actionLabel="Clear Filters"
                onAction={() => setFilter('')}
              />
            );
          }
          return visible.map((post) => (
          <PostCard
            key={post.id}
            post={post}
            onVote={handleVote}
            onOpenDebate={(p) => setActiveDebatePost(p)}
          />
          ));
        })()}
      </div>

      {/* Threaded Debate Modal */}
      {activeDebatePost && (
        <DebateModal
          post={activeDebatePost}
          onClose={() => setActiveDebatePost(null)}
        />
      )}
    </div>
  );
};
