'use strict';
const { castVote, fetchVoteCount } = require('../services/vote.service');

/**
 * POST /api/vote
 * Protected route — req.user is set by the authenticate middleware.
 * Converts frontend vote format to vote-service format and forwards.
 */
const vote = async (req, res, next) => {
  try {
    const { salaryId, vote: voteValue } = req.body;

    if (!salaryId) {
      return res.status(400).json({ error: 'salaryId is required' });
    }

    if (![1, 0, -1].includes(Number(voteValue))) {
      return res.status(400).json({ error: 'vote must be 1, 0, or -1' });
    }

    // Convert: 1 = upvote (true), -1 = downvote (false), 0 = no vote
    const upvote = Number(voteValue) === 1;

    const authHeader = req.headers.authorization;
    const result = await castVote({ submissionId: salaryId, upvote }, authHeader);
    return res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

const getVoteCount = async (req, res, next) => {
  try {
    const { id } = req.params;
    const result = await fetchVoteCount(id);
    return res.status(200).json(result);
  } catch (err) {
    next(err);
  }
};

module.exports = { vote, getVoteCount };
