import { Tokens } from './tokens.type';

export type User = {
  id: number;
  username: string;
  created_at: Date;
  updated_at: Date;
  tokens: Tokens;
};
